/**
 *  Copyright (c) 1999~2017, Altibase Corp. and/or its affiliates. All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License, version 3,
 *  as published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <uln.h>
#include <ulnPrivate.h>
#include <ulnConv.h>
#include <ulnConvToUBIGINT.h>
#include <ulnConvBit.h>
#include <ulnConvNumeric.h>

ACI_RC ulncCHAR_UBIGINT(ulnFnContext  *aFnContext,
                        ulnAppBuffer  *aAppBuffer,
                        ulnColumn     *aColumn,
                        ulnLengthPair *aLength,
                        acp_uint16_t   aRowNumber)
{
    acp_sint32_t sScale = 0;
    acp_sint64_t sBigIntValue;

    ACI_TEST_RAISE(ulncIsValidNumericLiterals((acp_char_t *)aColumn->mBuffer, aColumn->mDataLength, &sScale)
                   != ACP_TRUE,
                   LABEL_INVALID_LITERAL);

    /*
     * BUGBUG : �Ʒ��� �Լ��� signed long �� �����Ѵ�.
     *          �׷��� ������ 64bit integer �� signed �̹Ƿ� �� ���� ���� ���̴�.
     *          ID_ULONG_MAX �� �ʰ��ϴ����� üũ�� �ʿ� ����.
     *          ���� ������ �Ҽ��� ���ϰ� ©�ȴ����� üũ�ϸ� �ȴ�.
     */
    errno = 0;
    sBigIntValue = ulncStrToSLong((const acp_char_t *)aColumn->mBuffer, (acp_char_t **)NULL, 10);
    ACI_TEST_RAISE(errno == ERANGE, LABEL_OUT_OF_RANGE);

    ACI_TEST_RAISE(sBigIntValue < ACP_SINT64_LITERAL(0), LABEL_OUT_OF_RANGE_MINUS);

    if(sScale != 0)
    {
        /*
         * 01s07
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_IGNORE_FRACTIONAL_TRUNCATION);
    }

    *(acp_uint64_t *)aAppBuffer->mBuffer = sBigIntValue;

    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);
    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION(LABEL_INVALID_LITERAL)
    {
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_INVALID_NUMERIC_LITERAL);
    }

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE)
    {
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncVARCHAR_UBIGINT(ulnFnContext  *aFnContext,
                           ulnAppBuffer  *aAppBuffer,
                           ulnColumn     *aColumn,
                           ulnLengthPair *aLength,
                           acp_uint16_t   aRowNumber)
{
    return ulncCHAR_UBIGINT(aFnContext,
                            aAppBuffer,
                            aColumn,
                            aLength,
                            aRowNumber);
}

ACI_RC ulncVARBIT_UBIGINT(ulnFnContext  *aFnContext,
                          ulnAppBuffer  *aAppBuffer,
                          ulnColumn     *aColumn,
                          ulnLengthPair *aLength,
                          acp_uint16_t   aRowNumber)
{
    return ulncBIT_UBIGINT(aFnContext,
                           aAppBuffer,
                           aColumn,
                           aLength,
                           aRowNumber);
}

ACI_RC ulncBIT_UBIGINT(ulnFnContext  *aFnContext,
                       ulnAppBuffer  *aAppBuffer,
                       ulnColumn     *aColumn,
                       ulnLengthPair *aLength,
                       acp_uint16_t   aRowNumber)
{
    acp_uint8_t sBitValue;

    ACP_UNUSED(aFnContext);
    ACP_UNUSED(aRowNumber);

    sBitValue = ulnConvBitToUChar(aColumn->mBuffer);

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sBitValue;

    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);
    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;
}

ACI_RC ulncSMALLINT_UBIGINT(ulnFnContext  *aFnContext,
                            ulnAppBuffer  *aAppBuffer,
                            ulnColumn     *aColumn,
                            ulnLengthPair *aLength,
                            acp_uint16_t   aRowNumber)
{
    acp_sint16_t sSmallIntValue;

    sSmallIntValue = *(acp_sint16_t *)aColumn->mBuffer;

    ACI_TEST_RAISE(sSmallIntValue < 0, LABEL_OUT_OF_RANGE_MINUS);

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sSmallIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncINTEGER_UBIGINT(ulnFnContext  *aFnContext,
                           ulnAppBuffer  *aAppBuffer,
                           ulnColumn     *aColumn,
                           ulnLengthPair *aLength,
                           acp_uint16_t   aRowNumber)
{
    acp_sint32_t sSIntValue;

    sSIntValue = *(acp_sint32_t *)aColumn->mBuffer;

    ACI_TEST_RAISE(sSIntValue < 0, LABEL_OUT_OF_RANGE_MINUS);

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sSIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncBIGINT_UBIGINT(ulnFnContext  *aFnContext,
                          ulnAppBuffer  *aAppBuffer,
                          ulnColumn     *aColumn,
                          ulnLengthPair *aLength,
                          acp_uint16_t   aRowNumber)
{
    acp_sint64_t sBigIntValue;

    sBigIntValue = *(acp_sint64_t *)aColumn->mBuffer;

    ACI_TEST_RAISE(sBigIntValue < ACP_SINT64_LITERAL(0), LABEL_OUT_OF_RANGE_MINUS);

    *(acp_uint64_t *)aAppBuffer->mBuffer = sBigIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncREAL_UBIGINT(ulnFnContext  *aFnContext,
                        ulnAppBuffer  *aAppBuffer,
                        ulnColumn     *aColumn,
                        ulnLengthPair *aLength,
                        acp_uint16_t   aRowNumber)
{
    acp_sint64_t sBigIntValue;
    acp_float_t  sFloatValue;

    sFloatValue = *(acp_float_t *)aColumn->mBuffer;

    ACI_TEST_RAISE(sFloatValue < 0, LABEL_OUT_OF_RANGE_MINUS);
    ACI_TEST_RAISE(sFloatValue > ACP_UINT64_MAX, LABEL_OUT_OF_RANGE);

    sBigIntValue = (acp_sint64_t)sFloatValue;

    if(sBigIntValue != sFloatValue)
    {
        /*
         * 01s07
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_IGNORE_FRACTIONAL_TRUNCATION);
    }

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sBigIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE);
    }

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncDOUBLE_UBIGINT(ulnFnContext  *aFnContext,
                          ulnAppBuffer  *aAppBuffer,
                          ulnColumn     *aColumn,
                          ulnLengthPair *aLength,
                          acp_uint16_t   aRowNumber)
{
    acp_sint64_t sBigIntValue;
    acp_double_t sDoubleValue;


    sDoubleValue = *(acp_double_t *)aColumn->mBuffer;

    ACI_TEST_RAISE(sDoubleValue < 0, LABEL_OUT_OF_RANGE_MINUS);
    ACI_TEST_RAISE(sDoubleValue > ACP_UINT64_MAX, LABEL_OUT_OF_RANGE);

    sBigIntValue = (acp_sint64_t)sDoubleValue;

    if(sBigIntValue != sDoubleValue)
    {
        /*
         * 01s07
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_IGNORE_FRACTIONAL_TRUNCATION);
    }

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sBigIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE);
    }

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncINTERVAL_UBIGINT(ulnFnContext  *aFnContext,
                            ulnAppBuffer  *aAppBuffer,
                            ulnColumn     *aColumn,
                            ulnLengthPair *aLength,
                            acp_uint16_t   aRowNumber)
{
    ACP_UNUSED(aAppBuffer);
    ACP_UNUSED(aLength);

    /*
     * BUGBUG : ������ inteval Ÿ�Կ� single field �� ������ �����ϵ��� �ؾ� �ϴµ�,
     *          �ϴ� �̷��� ����.
     */

    /*
     * 07006
     */
    return ulnErrorExtended(aFnContext,
                            aRowNumber,
                            aColumn->mColumnNumber,
                            ulERR_ABORT_INVALID_CONVERSION);
}

ACI_RC ulncNUMERIC_UBIGINT(ulnFnContext  *aFnContext,
                           ulnAppBuffer  *aAppBuffer,
                           ulnColumn     *aColumn,
                           ulnLengthPair *aLength,
                           acp_uint16_t   aRowNumber)
{
    cmtNumeric  *sCmNumeric;
    ulncNumeric  sDecimal;
    acp_uint8_t  sBuffer[ULNC_NUMERIC_ALLOCSIZE];

    acp_uint64_t sBigIntValue = 0;
    acp_bool_t   sIsOverflow  = ACP_FALSE;

    sCmNumeric = (cmtNumeric *)aColumn->mBuffer;

    ACI_TEST_RAISE(sCmNumeric->mSign == 0, LABEL_OUT_OF_RANGE_MINUS);

    /*
     * cmtNumeric ���� ���� ULong ���� ���ϱ� overflow ����Ʈ�� �ʹ� �Ӹ����ļ�
     * �ϴ� ulncDecimal �� 10������ ��ȯ �� �� ULong ���� ������ �Ѵ�.
     */
    ulncNumericInitialize(&sDecimal, 10, ULNC_ENDIAN_BIG, sBuffer, ULNC_NUMERIC_ALLOCSIZE);
    ulncCmtNumericToDecimal((cmtNumeric *)aColumn->mBuffer, &sDecimal);

    sBigIntValue = ulncDecimalToULong(&sDecimal, &sIsOverflow);

    ACI_TEST_RAISE(sIsOverflow == ACP_TRUE, LABEL_OUT_OF_RANGE);

    if (sDecimal.mScale > 0)
    {
        /*
         * 01S07 : fractional truncation
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_IGNORE_FRACTIONAL_TRUNCATION);
    }

    *(acp_uint64_t *)aAppBuffer->mBuffer = (acp_uint64_t)sBigIntValue;

    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);
    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE);
    }

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION_END;

    return ACI_FAILURE;
}

ACI_RC ulncNCHAR_UBIGINT(ulnFnContext  *aFnContext,
                         ulnAppBuffer  *aAppBuffer,
                         ulnColumn     *aColumn,
                         ulnLengthPair *aLength,
                         acp_uint16_t   aRowNumber)
{
    acp_sint32_t  sScale = 0;
    acp_sint64_t  sBigIntValue;
    ulnDbc       *sDbc;
    ulnCharSet    sCharSet;
    acp_sint32_t  sState = 0;

    ulnCharSetInitialize(&sCharSet);
    sState = 1;

    ULN_FNCONTEXT_GET_DBC(aFnContext, sDbc);

    ACI_TEST( sDbc == NULL );     //BUG-28561 [CodeSonar] Null Pointer Dereference

    ACI_TEST(ulnCharSetConvert(&sCharSet,
                               aFnContext,
                               NULL,
                               (const mtlModule*)sDbc->mNcharCharsetLangModule,
                               sDbc->mClientCharsetLangModule,    //BUG-22684
                               (void*)aColumn->mBuffer,
                               aColumn->mDataLength,
                               CONV_DATA_OUT)
             != ACI_SUCCESS);

    ACI_TEST_RAISE(ulncIsValidNumericLiterals((acp_char_t *)ulnCharSetGetConvertedText(&sCharSet),
                                              ulnCharSetGetConvertedTextLen(&sCharSet),
                                              &sScale) != ACP_TRUE,
                   LABEL_INVALID_LITERAL);

    /*
     * BUGBUG : �Ʒ��� �Լ��� signed long �� �����Ѵ�.
     *          �׷��� ������ 64bit integer �� signed �̹Ƿ� �� ���� ���� ���̴�.
     *          ACP_UINT64_MAX �� �ʰ��ϴ����� üũ�� �ʿ� ����.
     *          ���� ������ �Ҽ��� ���ϰ� ©�ȴ����� üũ�ϸ� �ȴ�.
     */
    errno = 0;
    sBigIntValue = ulncStrToSLong((const acp_char_t *)ulnCharSetGetConvertedText(&sCharSet), (acp_char_t **)NULL, 10);
    ACI_TEST_RAISE(errno == ERANGE, LABEL_OUT_OF_RANGE);

    ACI_TEST_RAISE(sBigIntValue < ACP_SINT64_LITERAL(0), LABEL_OUT_OF_RANGE_MINUS);

    if(sScale != 0)
    {
        /*
         * 01s07
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_IGNORE_FRACTIONAL_TRUNCATION);
    }

    *(acp_uint64_t *)aAppBuffer->mBuffer = sBigIntValue;

    aLength->mWritten = ACI_SIZEOF(acp_uint64_t);
    aLength->mNeeded  = ACI_SIZEOF(acp_uint64_t);

    sState = 0;
    ulnCharSetFinalize(&sCharSet);

    return ACI_SUCCESS;

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE_MINUS)
    {
        /*
         * 22003
         */
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE_MINUS);
    }

    ACI_EXCEPTION(LABEL_INVALID_LITERAL)
    {
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_INVALID_NUMERIC_LITERAL);
    }

    ACI_EXCEPTION(LABEL_OUT_OF_RANGE)
    {
        ulnErrorExtended(aFnContext,
                         aRowNumber,
                         aColumn->mColumnNumber,
                         ulERR_ABORT_NUMERIC_VALUE_OUT_OF_RANGE);
    }

    ACI_EXCEPTION_END;

    if (sState == 1)
    {
        ulnCharSetFinalize(&sCharSet);
    }

    return ACI_FAILURE;
}

ACI_RC ulncNVARCHAR_UBIGINT(ulnFnContext  *aFnContext,
                            ulnAppBuffer  *aAppBuffer,
                            ulnColumn     *aColumn,
                            ulnLengthPair *aLength,
                            acp_uint16_t   aRowNumber)
{
    return ulncNCHAR_UBIGINT(aFnContext,
                             aAppBuffer,
                             aColumn,
                             aLength,
                             aRowNumber);
}