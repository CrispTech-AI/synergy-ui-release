from synergy_ui.retrieval.vector.main import VectorDBBase
from synergy_ui.retrieval.vector.main import VectorDBBase
from synergy_ui.retrieval.vector.type import VectorType
from synergy_ui.config import (
    VECTOR_DB,
    ENABLE_QDRANT_MULTITENANCY_MODE,
    ENABLE_MILVUS_MULTITENANCY_MODE,
)


class Vector:

    @staticmethod
    def get_vector(vector_type: str) -> VectorDBBase:
        """
        get vector db instance by vector type
        """
        match vector_type:
            case VectorType.MILVUS:
                if ENABLE_MILVUS_MULTITENANCY_MODE:
                    from synergy_ui.retrieval.vector.dbs.milvus_multitenancy import (
                        MilvusClient,
                    )

                    return MilvusClient()
                else:
                    from synergy_ui.retrieval.vector.dbs.milvus import MilvusClient

                    return MilvusClient()
            case VectorType.QDRANT:
                if ENABLE_QDRANT_MULTITENANCY_MODE:
                    from synergy_ui.retrieval.vector.dbs.qdrant_multitenancy import (
                        QdrantClient,
                    )

                    return QdrantClient()
                else:
                    from synergy_ui.retrieval.vector.dbs.qdrant import QdrantClient

                    return QdrantClient()
            case VectorType.PINECONE:
                from synergy_ui.retrieval.vector.dbs.pinecone import PineconeClient

                return PineconeClient()
            case VectorType.S3VECTOR:
                from synergy_ui.retrieval.vector.dbs.s3vector import S3VectorClient

                return S3VectorClient()
            case VectorType.OPENSEARCH:
                from synergy_ui.retrieval.vector.dbs.opensearch import OpenSearchClient

                return OpenSearchClient()
            case VectorType.PGVECTOR:
                from synergy_ui.retrieval.vector.dbs.pgvector import PgvectorClient

                return PgvectorClient()
            case VectorType.ELASTICSEARCH:
                from synergy_ui.retrieval.vector.dbs.elasticsearch import (
                    ElasticsearchClient,
                )

                return ElasticsearchClient()
            case VectorType.CHROMA:
                from synergy_ui.retrieval.vector.dbs.chroma import ChromaClient

                return ChromaClient()
            case VectorType.ORACLE23AI:
                from synergy_ui.retrieval.vector.dbs.oracle23ai import Oracle23aiClient

                return Oracle23aiClient()
            case VectorType.WEAVIATE:
                from synergy_ui.retrieval.vector.dbs.weaviate import WeaviateClient

                return WeaviateClient()
            case _:
                raise ValueError(f"Unsupported vector type: {vector_type}")


VECTOR_DB_CLIENT = None
if VECTOR_DB and VECTOR_DB.lower() != "none":
    VECTOR_DB_CLIENT = Vector.get_vector(VECTOR_DB)

